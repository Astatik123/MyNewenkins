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
        script {
            // Check if the Docker network exists
            def networkExists = sh(script: 'docker network inspect zabbix-net > /dev/null 2>&1', returnStatus: true) == 0

            // If the network doesn't exist, create it
            if (!networkExists) {
                sh '''
                docker network create zabbix-net            
                '''
            } else {
                echo 'Docker network "zabbix-net" already exists.'
            }
        }
    }
}
          stage("Postgresql") {
    steps {
        script {
            // Check if the Docker container zabbix-postgres exists
            def containerExists = sh(script: 'docker inspect --format="{{.State.Running}}" zabbix-postgres > /dev/null 2>&1', returnStatus: true) == 0

            // If the container doesn't exist, run the PostgreSQL container
            if (!containerExists) {
                sh '''
                docker run -d \
                --name zabbix-postgres \
                --network zabbix-net \
                -v /var/lib/zabbix/timezone:/etc/timezone \
                -v /var/lib/zabbix/localtime:/etc/localtime \
                -e POSTGRES_PASSWORD=zabbix \
                -e POSTGRES_USER=zabbix \
                -d postgres:alpine
                '''
            } else {
                echo 'Docker container "zabbix-postgres" already exists.'
            }

            // Always pull the Zabbix image (not dependent on the condition)
            sh 'docker pull yurashupik/zabbix:1'
        }
    }
}

        stage("Zabbix server") {
    steps {
        script {
            // Check if the Docker container zabbix-server exists
            def containerExists = sh(script: 'docker inspect --format="{{.State.Running}}" zabbix-server > /dev/null 2>&1', returnStatus: true) == 0

            // If the container doesn't exist, run the Zabbix server container
            if (!containerExists) {
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
            } else {
                echo 'Docker container "zabbix-server" already exists.'
            }
        }
    }
}

        stage("Zabbix web server") {
    steps {
        script {
            // Check if the Docker container zabbix-web exists
            def containerExists = sh(script: 'docker inspect --format="{{.State.Running}}" zabbix-web > /dev/null 2>&1', returnStatus: true) == 0

            // If the container doesn't exist, run the Zabbix web server container
            if (!containerExists) {
                sh '''
                docker run \
                --name zabbix-web \
                -p 80:8081 -p 443:8443 \
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
            } else {
                echo 'Docker container "zabbix-web" already exists.'
            }
        }
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
                withCredentials([usernamePassword(credentialsId: 'ca2d1d1d-5a0f-470f-87c0-bde659a42cec', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
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

        stage("Build and Push Docker Image") {
            steps {
                script {
                    // Build and push Docker image to Docker Hub
                    docker.build("astatik/myzabbix:latest")
                    docker.withRegistry('https://registry.hub.docker.com', 'Docekr') {
                        docker.image("astatik/myzabbix:latest").push()
                    }
                }
            }
        }

        stage("Pull Docker Image") {
            steps {
                script {
                    // Pull Docker image from Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', 'Docekr') {
                        docker.image("astatik/myzabbix:latest").pull()
                    }
                }
            }
        }
    }
}
