from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import sys
import os
import argparse
import tensorflow as tf
import numpy as np
import facenet
import align.detect_face
import random


def main(args):
    output_dir = os.path.expanduser(args.out_dir)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    src_path, _ = os.path.split(os.path.realpath(__file__))
    facenet.store_revision_info(src_path, output_dir, ' '.join(sys.argv))
    dataset = facenet.get_dataset(args.in_dir)

    print('Creating networks and loading parameters')

    with tf.Graph().as_default():
        sess = tf.compat.v1.Session()
        with sess.as_default():
            p_net, r_net, o_net = align.detect_face.create_mtcnn(sess, None)

    minsize = 20
    threshold = [0.6, 0.7, 0.7]
    factor = 0.709

    random_key = np.random.randint(0, high=99999)
    bounding_boxes_filename = os.path.join(output_dir, 'bounding_boxes_%05d.txt' % random_key)

    with open(bounding_boxes_filename, "w") as text_file:
        nrof_images_total = 0
        nrof_successfully_aligned = 0
        if args.random_order:
            random.shuffle(dataset)
        for cls in dataset:
            output_class_dir = os.path.join(output_dir, cls.name)
            if not os.path.exists(output_class_dir):
                os.makedirs(output_class_dir)
                if args.random_order:
                    random.shuffle(cls.image_paths)
            for image_path in cls.image_paths:
                nrof_images_total += 1
                filename = os.path.splitext(os.path.split(image_path)[1])[0]
                output_filename = os.path.join(output_class_dir, filename + '.png')
                print(image_path)
                if not os.path.exists(output_filename):
                    try:
                        import imageio
                        img = imageio.imread(image_path)
                    except (IOError, ValueError, IndexError) as e:
                        errorMessage = '{}: {}'.format(image_path, e)
                        print(errorMessage)
                    else:
                        if img.ndim < 2:
                            print('Unable to align "%s"' % image_path)
                            text_file.write('%s\n' % (output_filename))
                            continue
                        if img.ndim == 2:
                            img = facenet.to_rgb(img)
                        img = img[:, :, 0:3]

                        bounding_boxes, _ = align.detect_face.detect_face(img, minsize, p_net, r_net, o_net, threshold,
                                                                          factor)
                        print('\n')
                        print('rrrrrrr')
                        print(bounding_boxes)
                        print(_)
                        nrof_faces = bounding_boxes.shape[0]
                        if nrof_faces > 0:
                            det = bounding_boxes[:, 0:4]
                            det_arr = []
                            img_size = np.asarray(img.shape)[0:2]
                            if nrof_faces > 1:
                                # if args.detect_multiple_faces:
                                #     for i in range(nrof_faces):
                                #         det_arr.append(np.squeeze(det[i]))
                                # else:
                                bounding_box_size = (det[:, 2] - det[:, 0]) * (det[:, 3] - det[:, 1])
                                img_center = img_size / 2
                                offsets = np.vstack([(det[:, 0] + det[:, 2]) / 2 - img_center[1],
                                                     (det[:, 1] + det[:, 3]) / 2 - img_center[0]])
                                offset_dist_squared = np.sum(np.power(offsets, 2.0), 0)
                                index = np.argmax(
                                    bounding_box_size - offset_dist_squared * 2.0)  # some extra weight on the centering
                                det_arr.append(det[index, :])
                            else:
                                det_arr.append(np.squeeze(det))

                            for i, det in enumerate(det_arr):
                                det = np.squeeze(det)
                                bb = np.zeros(4, dtype=np.int32)
                                bb[0] = np.maximum(det[0] - 16, 0)
                                bb[1] = np.maximum(det[1] - 16, 0)
                                bb[2] = np.minimum(det[2] + 16, img_size[1])
                                bb[3] = np.minimum(det[3] + 16, img_size[0])
                                cropped = img[bb[1]:bb[3], bb[0]:bb[2], :]
                                from PIL import Image
                                cropped = Image.fromarray(cropped)
                                scaled = cropped.resize((160, 160), Image.BILINEAR)
                                nrof_successfully_aligned += 1
                                filename_base, file_extension = os.path.splitext(output_filename)
                                output_filename_n = "{}{}".format(filename_base, file_extension)
                                imageio.imwrite(output_filename_n, scaled)
                                text_file.write('%s %d %d %d %d\n' % (output_filename_n, bb[0], bb[1], bb[2], bb[3]))
                        else:
                            print('Unable to align "%s"' % image_path)
                            text_file.write('%s\n' % (output_filename))

    print('Total number of images: %d' % nrof_images_total)
    print('Number of successfully aligned images: %d' % nrof_successfully_aligned)


def parse_arguments(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('in_dir', type=str, help='Directory with unaligned images.')
    parser.add_argument('out_dir', type=str, help='Directory with aligned face thumbnails.')
    parser.add_argument('--random_order',
                        help='Shuffles the order of images to enable alignment using multiple processes.',
                        action='store_true')
    return parser.parse_args(argv)


if __name__ == '__main__':
    main(parse_arguments(sys.argv[1:]))
