# Use the official Microsoft dotnet core runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the official Microsoft dotnet core image to build artifact
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY "thebank.csproj" .
RUN dotnet restore "thebank.csproj"
# Copy local code to the container image.
COPY . .
RUN dotnet build . -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "thebank.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Invoke dotnet at commandline at startup
ENTRYPOINT ["dotnet", "thebank.dll"]