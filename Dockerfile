#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build
WORKDIR /src
COPY ["ReproduceJapaneseCalendarBug/ReproduceJapaneseCalendarBug.csproj", "ReproduceJapaneseCalendarBug/"]
RUN dotnet restore "ReproduceJapaneseCalendarBug/ReproduceJapaneseCalendarBug.csproj"
COPY . .
WORKDIR "/src/ReproduceJapaneseCalendarBug"
RUN dotnet build "ReproduceJapaneseCalendarBug.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ReproduceJapaneseCalendarBug.csproj" -c Release -o /app/publish --self-contained false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ReproduceJapaneseCalendarBug.dll"]