## Create ASP.Net Core Web App
## -----------------------------------------

mkdir netcoreapp
cd netcoreapp

dotnet new -t web

dotnet restore

dotnet run 


## Generate Docker Image
## -----------------------------------------

# Use Docker Support tools in VS or manually create the dockerfile

dotnet build -c release

dotnet publish -c release -o app 

docker build -t netcoreapp:v1 .

docker images

docker ps

docker run -p 5000:80 -t netcoreapp:v1


## Push Docker Image to Azure Container Registry
## ----------------------------------------------

docker login jomit-microsoft.azurecr.io -u jomit -p =R+/+xy/+et8C=onQwlwsM+V7GGZBeXN

docker tag netcoreapp:v1 jomit-microsoft.azurecr.io/samples/netcoreapp:v1

docker push jomit-microsoft.azurecr.io/samples/netcoreapp:v1


## Testing pushed image
## ---------------------------------------------

docker pull jomit-microsoft.azurecr.io/samples/netcoreapp:v1

docker run -it --rm -p 5000:80 jomit-microsoft.azurecr.io/samples/netcoreapp:v1


## Other Docker Commands
## ------------------------------------------

docker rm $(docker ps -a -q)

docker rmi netcoreapp:v1

docker search microsoft

docker history netcoreapp:v1

docker history --no-trunc microsoft/dotnet:latest   