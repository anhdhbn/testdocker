FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["TestDocker/TestDocker.csproj", "TestDocker/"]
RUN dotnet restore "TestDocker/TestDocker.csproj"
COPY . .
WORKDIR "/src/TestDocker"
RUN dotnet build "TestDocker.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TestDocker.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TestDocker.dll"]