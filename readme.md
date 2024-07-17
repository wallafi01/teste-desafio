# DevOps Challenge

## Descrição


O processo de automação CI/CD na AWS EC2, através de uma pipeline integrada com GitHub Actions, será composto pelo AWS CodePipeline e AWS CodeDeploy. Esse processo será iniciado automaticamente após commits e push no repositório GitHub.

GitHub Actions será configurado para disparar automaticamente em push para o branch principal, acionando o início do pipeline. O AWS CodePipeline integrará o repositório GitHub com o AWS CodeDeploy, coordenando todo o fluxo de entrega contínua.

A infraestrutura será criada pelo Terraform e o AWS CodeDeploy será responsável por automatizar o deployment na instância EC2, garantindo a eficiência e a confiabilidade no processo de atualização contínua da aplicação. Com essa configuração, o processo de deployment se torna mais ágil e seguro, minimizando riscos e reduzindo o tempo de inatividade.


### Tecnologias Utilizadas
 
- Github
- GitHub Actions
- Terraform
- CodeDeploy
- CodePipeline
- Ansible

## Diagrama da Solução


  ![alt text](./diagrama/pipeline.drawio.png)

## Instruções

## 1 - Configurações iniciais

**1.** Para começar, é essencial ter acesso à plataforma AWS para gerenciar seus recursos na nuvem de forma eficiente.

**2.** Crie um usuário na AWS e gere "Secret Keys" para acesso seguro aos recursos AWS via linha de comando. É recomendado não compartilhar essas "Secret Keys" para manter a segurança dos seus dados.

    - Selecione as políticas apropriadas, como AmazonEC2FullAccess, AmazonVPCFullAccess, AmazonCodeDeployFullAccess ou crie uma política personalizada com as permissões necessárias para seu projeto.

**3.** Criar um Bucket que servirá como um backend e armazenara o arquivo terraform.state gerado
  ![alt text](./images/Screenshot_20.png)


**4. Configurar as variaveis para o Deploy na infraestrutra no arquivo ./src/variables.tf**

  ![alt text](./images/Screenshot_18.png)

  - Observação : Por questões de segurança e recomendado criar a chave .pem na qual será para o acesso a EC2 ,diretamente na console e adicionar o nome da chave no campo variable "key_pair".

**5. Configurar as variaveis e Secrets para o funcionamento da Pipeline no arquivo ./github/workflows/main.yaml**  

**Etapa 1 - Deploy da Infraestrtura com Trerraform**

    - Objetivo desta etapa e a implantação de uma Infra AWS ,contendo EC2 , S3 , VPC e CodeDeploy.

  ![alt text](./images/Screenshot_21.png) 
  ![alt text](./images/Screenshot_22.png)

 - No repositorio > Settings > Security (Secrets and variabels) > actions > Secrets : Repository Secrets > New Repository Secrets , adicionar todas as secrets selecionadas.

 - **AWS_ACCESS_KEY_ID  / AWS_SECRET_ACCESS_KEY**  - Chaves programaticas geradas na console na etapa incial.
 - **AWS_BUCKET_NAME** - Nome do bucket criado na console , para gerenciar o estado do terraform.
 - **AWS_BUCKET_FILE** - Nome do arquivo gerado pelo terraform (ex: terraform.tfstate).
 
**Etapa 2 - Informações da EC2:**

    - Objetivo desta etapa e obter as informações da ec2 como o IP público para o ansible acessa-lá.

  ![alt text](./images/Screenshot_25.png)   

  - No repositorio > Settings > Security (Secrets and variabels) > actions > variables >  Repository variables > New Reposiroty Secrets , adicionar a variavel abaixo .

 - **NAME_EC2** - Deverá conter o mesmo nome da instancia , implantada pelo terraform conforme abaixo no arquivo ./src/variables.tf.

  ![alt text](./images/Screenshot_29.png)    

**Etapa 3 - Provisionamento com Ansible:**

    - Objetivo desta etapa e instalar o Agent do Code Deploy na ec2.

  ![alt text](./images/Screenshot_24.png)

 - **SSH_PRIVATE_KEY**  - Adicionar o conteudo da chave ".pem" criada na console para o ansible conseguir acessar o servidor.


**Etapa 4 - Deploy com CodeDeploy:**

    - Nesta etapa o CodeDeploy irá realizar a implantação na EC2.


  ![alt text](./images/Screenshot_26.png)  


 - **AWS_BUCKET_DEPLOY_NAME**  - Adicionar na Secrets , o nome do bucket que irá receber os Artiacts do CodeDeploy , o nome deverá ser o mesmo que foi definido no terraform .
 - **NAME_APP / NAME_GROUP** - Adicionar como variaveis , o o nome deverá ser o mesmo que foi definido no terraform conforme abaixo:

  ![alt text](./images/Screenshot_27.png)

- **SOURCE_PATH: ./deploy** - Adicionar o path que contenha o appspec.yml e os scripts.

  ![alt text](./images/Screenshot_28.png)

**Etapa 5 - Criação CodePipeline:**

    - Nesta etapa o iremos criar o CodePipeline , para realizar a integração do Repositorio juntamente ao CodeDeploy.
    - Observação: A criação da ferramenta será via console , poís será preciso realizar autenticação juntamente ao GitHub.

  ir em Code Pipeline > criar Pipeline.

  ![alt text](./images/Screenshot_5.png)

  Adicionar repositorio , precisara autenticar ao github  .

  ![alt text](./images/Screenshot_6.png)


  No acionador manter essas configurações.

  ![alt text](./images/Screenshot_8.png)

  Ignorar etapa de compilação.

  ![alt text](./images/Screenshot_9.png)

  Etapa de implantação , selecionar o CodeDeploy como provedor , Nome do aplicativo eo Grupo de implantação.

  ![alt text](./images/Screenshot_10.png)

  Proximo , revisar e criar pipeline  .


## 2 - Piipeline CI/CD

**1. GitHub Repositório (Push)**
Após realizar alterações no código-fonte da aplicação , fazer o commit para o repositório GitHub.

**2. GitHub Actions (Trigger)**
GitHub Actions é configurado para monitorar o repositório em busca de alterações no branch principal(main)

Configuração: No diretório .github/workflows/main.yaml, ira definir a pipeline de CI/CD.

**3. Criar AWS code Deploy**

Configuração: Para configurar o CodeDeploy, você precisa de três coisas: o aplicativo CodeDeploy, o grupo de implantação do aplicativo e uma função do IAM que o CodeDeploy pode assumir para acessar as instâncias do EC2.

  **Criar um aplicativo:**
    
  Navegue até o Console do CodeDeploy, no painel esquerdo, clique em “ Aplicativos ” na seção “Implementar” e selecione “Criar aplicativo”.

  ![alt text](./images/Screenshot_1.png)


  Em seguida, forneça o nome do seu aplicativo e use a plataforma “ EC2/On-premises ”.

  #Criar função do IAM do CodeDeploy#

  Vá para a seção IAM e crie uma nova função

  ![alt text](./images/Screenshot_2.png)

  Use “ AWS Service ” para entidade confiável e selecione “ CodeDeploy ” no menu suspenso para “Caso de uso”.

  Clique em Avançar e use a política “AWSCodeDeployRole” anexada.

  ![alt text](./images/Screenshot_3.png)


  Dê um nome à função e salve.

  **Criar um grupo de implantação**

  Vá para o aplicativo que você criou anteriormente e clique em “Criar grupo de implantação”.

  Forneça um nome para seu grupo de implantação e selecione a função que criamos anteriormente para a função de serviço.

  Você pode deixar o tipo de implantação nas configurações padrão. Selecione “Amazon EC2 instances” para alvos e use tags para identificá-los.

  ![alt text](./images/Screenshot_4.png)

  Selecione “ Nunca” na configuração do agente, instalaremos o agente CodeDeploy será instalado no user data da ec2 implantada pelo terraform

  Você pode selecionar a configuração de implantação “OneAtATime” e habilitar o balanceamento de carga se tiver mais de uma instância , caso contrário, desmarque a opção de balanceamento de carga.

  Em seguida, clique no botão criar grupo de implantação.


**4. Trigger para o CodeDeploy**

  **arquivo: appspec.yml**

  o arquivo appspec.yml , localizado na raiz do repositorio informará o CodeDeploy Agent sobre os comandos que você deseja executar durante a implantação

  ![alt text](./images/Screenshot_16.png)  


  **arquivo: scripts/deploy.sh**

  Será responsavel por fazer o deploy do repositorio

  Gerar um token do repositorio , e criar uma secrets no repositorio com nome "token_git" e adicionaro token

  ![alt text](./images/Screenshot_19.png) 






**6. Trigger Github Actions**

  **arquivo github/workflows/main.yaml** 

  ![alt text](./images/Screenshot_15.png)

        - //Criar secrets no repositorio , conforme as chave Secreta do usuario//

        - aws_access_key: ${{ secrets.AWS_ACCESS_KEY }} 
        - aws_secret_key: ${{ secrets.AWS_SECRET_KEY }} 

        - aws_region: us-east-1
        - codedeploy_name: app-challenge  //Nome da aplicação criado
        - codedeploy_group: group-app-challenge  // Nome do Grupo de Implantação
        - s3_bucket: s3-app-challenge01  // Nome do do bucket **(no qual foi criado pelo terraform)**
        - s3_folder: deploy // nome da pasta que ficará dentro do bucket

        - e descomentar : o bloco  #push: /#branches:main

será disparado após modificação do repositorio







>  This is a challenge by [Coodesh](https://coodesh.com/)

