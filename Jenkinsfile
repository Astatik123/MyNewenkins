pipeline {
    agent {
        docker {
            image 'zabbix/zabbix-server-mysql:latest'
            args '-p 8080:80'
        }
    }
    stages {
        stage('Run Zabbix Server') {
            steps {
                sh 'docker run -d --name zabbix-server-mysql -e DB_SERVER_HOST="mysql-server" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" -e MYSQL_DATABASE="zabbix" -p 10051:10051 zabbix/zabbix-server-mysql:latest'
            }
        }
    }
}
