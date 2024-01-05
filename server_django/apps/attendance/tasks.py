# import os
# from django.conf import settings
# import subprocess
#
# from celery import shared_task
#
# current_file_path = os.path.abspath(__file__)
# project_path = os.path.dirname(os.path.dirname(current_file_path))
#
# CLF_PATH = os.path.join(project_path, 'register_face/Models/facemodel.pkl')
# FACENET_MODEL_PATH = os.path.join(project_path, 'register_face/Models/20180402-114759.pb')
# @shared_task
# def load_model(user_id, video_path):
#     tf.compat.v1.disable_eager_execution()
#     # Load The Custom Classifier
#     with open(CLF_PATH, 'rb') as file:
#         model, class_names = pickle.load(file)
#     print("Custom Classifier, Successfully loaded")
#
#     tf.Graph().as_default()
#
#     # Cai dat GPU neu co
#     gpu_options = tf.compat.v1.GPUOptions(per_process_gpu_memory_fraction=0.6)
#     sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(gpu_options=gpu_options, log_device_placement=False))
#
#     # Load the model
#     print('Loading feature extraction model')
#     facenet.load_model(FACENET_MODEL_PATH)
#
#     # Get input and output tensors
#     images_placeholder = tf.compat.v1.get_default_graph().get_tensor_by_name("input:0")
#     embeddings = tf.compat.v1.get_default_graph().get_tensor_by_name("embeddings:0")
#     phase_train_placeholder = tf.compat.v1.get_default_graph().get_tensor_by_name("phase_train:0")
#     embedding_size = embeddings.get_shape()[1]
#     model_path = os.path.join(project_path, 'register_face/src/align')
#     p_net, r_net, o_net = create_mtcnn(sess, model_path)
#     user_id = []
#     print('run tasskkkk')