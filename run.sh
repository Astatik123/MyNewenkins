#!groovy
//  groovy Jenkinsfile
properties([disableConcurrentBuilds()])\

pipeline  {
        agent { 
           label ''
        }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
       
        stage("base") {
            steps {
                sh '''
        
                '''
            } 
        }
        stage("network") {
            steps {
                sh '''
                docker network create zabbix-net            
                '''
            }
        }
          stage("Postgresql") {
            steps {
                sh '''
                docker run -d \
                --name zabbix-postgres \
                --network zabbix-net \
                -v /var/lib/zabbix/timezone:/etc/timezone \
                -v /var/lib/zabbix/localtime:/etc/localtime \
                -e POSTGRES_PASSWORD=zabbix \
                -e POSTGRES_USER=zabbix \
                -d postgres:alpine
                   docker pull yurashupik/zabbix:1
                '''
            }
          }
        stage("Zabbix server") {
            steps {
                sh '''
                docker run \
                --name zabbix-server \
                --network zabbix-net \
                -v /var/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts \
                -v /var/lib/zabbix/timezone:/etc/timezone \
                -v /var/lib/zabbix/localtime:/etc/localtime \
                -p 10051:10051 -e DB_SERVER_HOST="zabbix-postgres" \
                -e POSTGRES_USER="zabbix" \
                -e POSTGRES_PASSWORD="zabbix" \
                -d zabbix/zabbix-server-pgsql:alpine-latest
                '''
            }
        }
        stage("Zabbix web server") {
            steps {
                sh '''
                docker run \
                --name zabbix-web \
                -p 80:8080 -p 443:8443 \
                --network zabbix-net \
                -e DB_SERVER_HOST="zabbix-postgres" \
                -v /var/lib/zabbix/timezone:/etc/timezone \
                -v /var/lib/zabbix/localtime:/etc/localtime \
                -e POSTGRES_USER="zabbix" \
                -e POSTGRES_PASSWORD="zabbix" \
                -e ZBX_SERVER_HOST="zabbix-server" \
                -e PHP_TZ="Europe/Kiev" \
                -d zabbix/zabbix-web-nginx-pgsql:alpine-latest
                '''
            }
        }
        stage("run") {
            steps {
                sh '''
                docker start zabbix-postgres
                docker start zabbix-server
                docker start zabbix-web
                '''
            }
        }
    
                
        stage("docker login") {
            steps {
                echo " ============== docker login =================="
                withCredentials([usernamePassword(credentialsId: 'Docker/******', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        def loginResult = sh(script: "docker login -u $USERNAME -p $PASSWORD", returnStatus: true)
                        if (loginResult != 0) {
                            error "Failed to log in to Docker Hub. Exit code: ${loginResult}"
                        }
                    }
                }
                echo " ============== docker login completed =================="
            }
        }

        stage("docker push") {
            steps {
                echo " ============== pushing image =================="
                sh '''
                
                '''
            }
        }
    }
}
