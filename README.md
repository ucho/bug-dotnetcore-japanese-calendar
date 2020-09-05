# Reproduction of .NET Core JapaneseCalendar Bug

## Target code

- [Program.cs](./Program.cs)

```csharp
var cultureInfo = new CultureInfo("ja-JP", false)
{
    DateTimeFormat = { Calendar = new JapaneseCalendar() }
};
var date = DateTime.Parse("令和1年6月1日", cultureInfo);
Console.WriteLine(date.ToString("yyyy/MM/dd"));
```

- [Dockerfile](./Dockerfile)

```Dockerfile
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
```

## Expected output
```
2019/06/01
```

## Actual output
```
System.ArgumentOutOfRangeException: Not a valid calendar for the given culture.
```

## Addtional information

I confirmed that this error occurs only on alpine image, not on local or other images.
