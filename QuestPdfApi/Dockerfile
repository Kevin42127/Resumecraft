# 使用官方 .NET 8.0 運行時映像
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5101

# 使用官方 .NET 8.0 SDK 映像進行建置
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 複製專案文件
COPY ["QuestPdfApi.csproj", "./"]
RUN dotnet restore "QuestPdfApi.csproj"

# 複製所有源代碼
COPY . .
RUN dotnet build "QuestPdfApi.csproj" -c Release -o /app/build

# 發布
FROM build AS publish
RUN dotnet publish "QuestPdfApi.csproj" -c Release -o /app/publish

# 最終映像
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# 安裝 curl 用於健康檢查
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["dotnet", "QuestPdfApi.dll"] 