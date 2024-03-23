
import boto3


access_key_id = 'AKIAXYKJTW444PDPTXUK'
secret_access_key = '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'


s3 = boto3.client('s3', aws_access_key_id=access_key_id, aws_secret_access_key=secret_access_key)


bucket_name_1 = 'superNikitaBucket12323434521231'


s3.create_bucket(Bucket=bucket_name_1)


bucket_name_2 = 'superNikitaBucket1232343452123123423423'


s3.create_bucket(Bucket=bucket_name_2)

file_path_1 = '/home/ubuntu/newfileonpython.txt'
file_path_2 = '/home/ubuntu/newfileasdasf.txt'


s3.upload_file(file_path_1, bucket_name_1, 'file_1.txt')

s3.upload_file(file_path_2, bucket_name_2, 'file_2.txt')
