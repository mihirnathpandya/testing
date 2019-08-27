FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["testing/testing.csproj", "testing/"]
RUN dotnet restore "testing/testing.csproj"
COPY . .
WORKDIR "/src/testing"
RUN dotnet build "testing.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "testing.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "testing.dll"]