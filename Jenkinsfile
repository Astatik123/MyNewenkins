    pipeline {
    agent any

    stages {
        stage('Create Buckets') {
            steps {
                script {
                    // Замініть на ваші дані AWS
                    def awsAccessKeyId = 'AKIAXYKJTW444PDPTXUK'
                    def awsSecretAccessKey = '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'

                    def region = 'eu-north-1'

                    // Створення boto3 session
                    def session = boto3.session.Session(
                        aws_access_key_id: awsAccessKeyId,
                        aws_secret_access_key: awsSecretAccessKey,
                        region_name: region
                    )

                    // Створення клієнта S3
                    def s3 = session.client('s3')

                    // Створення 2 відер
                    def bucket1Name = 'mykyta1994031414031994'
                    def bucket2Name = 'mykytaspecialstyle1234567890'
                    s3.create_bucket(Bucket=bucket1Name)
                    s3.create_bucket(Bucket=bucket2Name)
                }
            }
        }
        stage('Upload Files') {
            steps {
                script {
                    // Замініть на ваші дані
                    def bucket1Name = 'bucket-1-name'
                    def bucket2Name = 'bucket-2-name'
                    def localFile1 = '/home/ubuntu/newfileonpython.txt'
                    def localFile2 = '/home/ubuntu/newfileasdasf.txt'

                    // Завантаження файлів
                    s3.upload_file(bucket1Name, localFile1)
                    s3.upload_file(bucket2Name, localFile2)
                }
            }
        }
    }
}
