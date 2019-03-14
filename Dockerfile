FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
#  apt-get install -y apt-utils && \
  apt-get install -y nano &&\
  apt-get install -y curl

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["TestDocker/TestDocker.csproj", "TestDocker/"]
RUN dotnet restore "TestDocker/TestDocker.csproj"

WORKDIR "/src/TestDocker"
COPY . .
RUN cat TestDocker/Views/Home/Index.cshtml
RUN dotnet build "TestDocker.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TestDocker.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TestDocker.dll"]
