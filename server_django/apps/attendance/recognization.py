from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import datetime

import tensorflow as tf
import os
import pickle
from apps.register_face.src.align.detect_face import detect_face, create_mtcnn
from apps.register_face.src import facenet
import numpy as np
import cv2
import base64

current_file_path = os.path.abspath(__file__)
project_path = os.path.dirname(os.path.dirname(current_file_path))

CLF_PATH = os.path.join(project_path, 'register_face/Models/facemodel.pkl')
FACENET_MODEL_PATH = os.path.join(project_path, 'register_face/Models/20180402-114759.pb')


def recognization_user(images):
    start_time = datetime.datetime.now()
    print('Load model')
    tf.compat.v1.disable_eager_execution()
    # Load The Custom Classifier
    with open(CLF_PATH, 'rb') as file:
        model, class_names = pickle.load(file)
    print("Custom Classifier, Successfully loaded")

    tf.Graph().as_default()

    # Cai dat GPU neu co
    gpu_options = tf.compat.v1.GPUOptions(per_process_gpu_memory_fraction=0.6)
    sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(gpu_options=gpu_options, log_device_placement=False))

    # Load the model
    print('Loading feature extraction model')
    facenet.load_model(FACENET_MODEL_PATH)

    # Get input and output tensors
    images_placeholder = tf.compat.v1.get_default_graph().get_tensor_by_name("input:0")
    embeddings = tf.compat.v1.get_default_graph().get_tensor_by_name("embeddings:0")
    phase_train_placeholder = tf.compat.v1.get_default_graph().get_tensor_by_name("phase_train:0")
    embedding_size = embeddings.get_shape()[1]
    model_path = os.path.join(project_path, 'register_face/src/align')
    p_net, r_net, o_net = create_mtcnn(sess, model_path)
    user_id = []

    for image in images:
        name = "Unknown"
        frame = np.fromstring(image.read(), dtype=np.uint8)
        frame = cv2.imdecode(frame, cv2.IMREAD_ANYCOLOR)

        bounding_boxes, _ = detect_face(frame, 20, p_net, r_net, o_net, [0.6, 0.7, 0.7], 0.709)
        faces_found = bounding_boxes.shape[0]

        if faces_found > 0:
            print('faces_found')
            det = bounding_boxes[:, 0:4]
            bb = np.zeros((faces_found, 4), dtype=np.int32)
            for i in range(faces_found):
                bb[i][0] = det[i][0]
                bb[i][1] = det[i][1]
                bb[i][2] = det[i][2]
                bb[i][3] = det[i][3]
                cropped = frame
                # cropped = frame[bb[i][1]:bb[i][3], bb[i][0]:bb[i][2], :]
                scaled = cv2.resize(cropped, (160, 160),
                                    interpolation=cv2.INTER_CUBIC)
                scaled = facenet.prewhiten(scaled)
                scaled_reshape = scaled.reshape(-1, 160, 160, 3)
                feed_dict = {images_placeholder: scaled_reshape, phase_train_placeholder: False}
                emb_array = sess.run(embeddings, feed_dict=feed_dict)
                predictions = model.predict_proba(emb_array)
                best_class_indices = np.argmax(predictions, axis=1)
                best_class_probabilities = predictions[
                    np.arange(len(best_class_indices)), best_class_indices]
                best_name = class_names[best_class_indices[0]]
                end_time = datetime.datetime.now()
                print("start time: {}".format(start_time))
                print("end time: {}".format(end_time))
                time = start_time - end_time
                print(time)
                print(time.seconds)
                print("ID: {}, Probability: {}, time: {}".format(best_name, best_class_probabilities, (end_time - start_time)))

                if best_class_probabilities > 0.75:
                    name = class_names[best_class_indices[0]]
                else:
                    print('go heeee 123')
                    name = "Unknown"

        else:
            return False
            print('not found face')
        if len(user_id) == 0:
            user_id.append(name)
        else:
            if name not in user_id:
                tf.compat.v1.reset_default_graph()
                return False
    tf.compat.v1.reset_default_graph()
    if len(user_id) == 0:
        return False
    else:
        return user_id[0]

