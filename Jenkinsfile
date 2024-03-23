
import boto3

# Введіть ваші ключі AWS
access_key_id = 'AKIAXYKJTW444PDPTXUK'
secret_access_key = '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'

# Створення клієнта S3
s3 = boto3.client('s3', aws_access_key_id=access_key_id, aws_secret_access_key=secret_access_key)

# Назва першого відра
bucket_name_1 = 'superNikitaBucket12323434521231'

# Створення першого відра
s3.create_bucket(Bucket=bucket_name_1)

# Назва другого відра
bucket_name_2 = 'superNikitaBucket1232343452123123423423'

# Створення другого відра
s3.create_bucket(Bucket=bucket_name_2)

# Шлях до файлів для завантаження
file_path_1 = '/home/ubuntu/newfileonpython.txt'
file_path_2 = '/home/ubuntu/newfileasdasf.txt'

# Завантаження файлу в перше відро
s3.upload_file(file_path_1, bucket_name_1, 'file_1.txt')

# Завантаження файлу в друге відро
s3.upload_file(file_path_2, bucket_name_2, 'file_2.txt')
