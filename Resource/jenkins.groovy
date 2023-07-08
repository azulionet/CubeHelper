pipeline {
    agent any
    
    environment {
        CREDENTIALS_ID = "Azu's Cube Helper"
        BUCKET = 'gs://azu-s-cube-helper.appspot.com'
        PATTERN = "filtered_card.json, uploader_card.json"
    }

    stages {
        stage('Hello') {
            steps {
                
                echo 'hello world start'
                
                git branch: 'main', credentialsId: 'git2', url: 'https://github.com/azulionet/CubeHelper.git'

                echo 'git clone end'
                
            }
        }
        stage('file donwload & filtering') {
            steps {

                echo 'file download & filtering'

                dir('Resource') {

                    bat 'scryfall_data_download_and_filter.py'
                    
                    // sh 'gsutil cp file.txt gs://bucket-name' // 파일 복사 예시
                    
                    step([$class: 'ClassicUploadStep',
                        credentialsId: env.CREDENTIALS_ID, 
                        bucket: "gs://azu-s-cube-helper.appspot.com/carddata",
                        pattern: env.PATTERN])
                    
                    echo 'python script end'
                }
            }        
        }    
    }
}
