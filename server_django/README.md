# Face-Recognition-Time-Attendance-System-Server

Step 1: start virtual environment: venv\Scripts\activate.bat

Step 2: install necessary package: pip install -r requirements.txt

Step 3: Download files pretrain model of FaceNet at https://drive.google.com/file/d/1EXPBSXwTaqrSC0OhUdXNmKSh9qJUQ55-/view
and extract to apps/register_face/Models/ 

Step 4: py manage.py makemigrations

Step 5: py manage.py migrate

Step 6: py manage.py runserver 0.0.0.0:8000

run redis-server, when other terminal, run statement "celery -A firefly_server worker -l info -P threads"


