import os
from django.conf import settings
import subprocess

from celery import shared_task

current_file_path = os.path.abspath(__file__)
project_path = os.path.dirname(os.path.dirname(current_file_path))
raw_images_dir = f'Dataset/raw/'
processed_images_dir = f'Dataset/processed/'
raw_images_dir = os.path.join(settings.MEDIA_ROOT, raw_images_dir)
processed_images_dir = os.path.join(settings.MEDIA_ROOT, processed_images_dir)

@shared_task
def handle_video_train_model_task(user_id, video_path):
    print('run tasskkkk')
    result = capture_image(user_id, video_path)
    return result



def capture_image(user_id, video_path):
    run_file = os.path.join(project_path, 'src/capture_image_from_video.py')
    output_images_dir = os.path.join(raw_images_dir, str(user_id))
    command = f'python {run_file} --video_path {video_path} --output_images_dir {output_images_dir} --user_id {user_id}'

    print(f'command: {command}')
    print('\n\n')
    process = subprocess.Popen(command.split(), stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()

    if process.returncode == 0:
        print("Capture done")

        align_face()
        return True
    else:
        print(f"Capture images command failed with error: {error.decode()}")
        return False


def align_face():
    run_file = os.path.join(project_path, 'src/align_dataset_mtcnn.py')
    in_dir = raw_images_dir
    out_dir = processed_images_dir

    command = f'python {run_file} {in_dir} {out_dir} --random_order'
    print(f'command: {command}')
    print('\n\n')
    process = subprocess.Popen(command.split(), stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    print(output)

    if process.returncode == 0:
        print('align_face done')
        train_data()
        return True
    else:
        print(f"align_face command failed with error: {error.decode()}")
        return False


def train_data():
    run_file = os.path.join(project_path, 'src/classifier.py')
    in_dir = processed_images_dir
    model = os.path.join(project_path, 'Models/20180402-114759.pb')
    clf_file = os.path.join(project_path, 'Models/facemodel.pkl')

    command = f'python {run_file} TRAIN {in_dir} {model} {clf_file}'
    print(f'command: {command}')
    print('\n\n')
    process = subprocess.Popen(command.split(), stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    print(output)

    if process.returncode == 0:
        print("train_data done")
        return True
    else:
        print(f"train_data command failed with error: {error.decode()}")
        return False
