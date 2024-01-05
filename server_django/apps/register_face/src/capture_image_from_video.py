import cv2
from datetime import datetime
import os
import time
import sys
import argparse


def main(args):
    print('-------------')
    video_path = args.video_path
    output_images_dir = args.output_images_dir
    if not os.path.exists(output_images_dir):
        os.makedirs(output_images_dir)
    user_id = args.user_id

    cam = cv2.VideoCapture(video_path)
    currentframe = 0

    while currentframe <= 150:
        ret, frame = cam.read()

        if ret:
            now = datetime.now()
            filename = user_id + '_' + now.strftime("%H%M%S") + '_' + str(currentframe) + ".png"
            img_path = os.path.join(output_images_dir, filename)
            print('=---------------')
            print(img_path)
            cv2.imwrite(img_path, frame)
            currentframe += 1
            time.sleep(0.001)
        else:
            break

    # Release all space and windows once done
    cam.release()
    cv2.destroyAllWindows()


def parse_arguments(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--video_path', type=str, help='The video path captured image')
    parser.add_argument('--output_images_dir', type=str, help='The raw folder contains images captured from video')
    parser.add_argument('--user_id', type=str, help='full_name')
    return parser.parse_args(argv)


if __name__ == '__main__':
    main(parse_arguments(sys.argv[1:]))
