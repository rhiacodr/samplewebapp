# Use the official .NET runtime as a base image for Windows
FROM mcr.microsoft.com/dotnet/aspnet:8.0-windowsservercore-ltsc2022 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK for build
FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2022 AS build
WORKDIR /src
COPY ["SampleWebApp.csproj", "./"]
RUN dotnet restore "./SampleWebApp.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet publish "SampleWebApp.csproj" -c Release -o /app/publish

# Build the runtime image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SampleWebApp.dll"]
