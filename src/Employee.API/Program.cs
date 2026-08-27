var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddOpenApi();

var health = "Running successfully with github-actions!.";

var appName = Environment.GetEnvironmentVariable("APP_NAME");
var version = Environment.GetEnvironmentVariable("APP_VERSION");
var company = Environment.GetEnvironmentVariable("COMPANY_NAME");

// SQL Database configuration
var dbServer = Environment.GetEnvironmentVariable("DB_SERVER");
var dbDatabase = Environment.GetEnvironmentVariable("DB_DATABASE");
var dbUser = Environment.GetEnvironmentVariable("DB_USERNAME");
var dbPassword = Environment.GetEnvironmentVariable("DB_PASSWORD");

var apiKey = Environment.GetEnvironmentVariable("API_KEY");

var connectionString =
    $"Server={dbServer};" +
    $"Database={dbDatabase};" +
    $"User Id={dbUser};" +
    $"Password={dbPassword};" +
    "TrustServerCertificate=True;";

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.MapGet("/", () =>
{
    return Results.Ok(new
    {
        Message = $"Welcome!. to {appName}",
        Version = version,
        Company = company
    });
});


app.MapGet("/api/config", () =>
{
    return Results.Ok(new
    {
        ApplicationName = appName,
        Version = version,
        Company = company,

        DatabaseServer = dbServer,
        DatabaseName = dbDatabase,
        DatabaseUser = dbUser,

        DatabaseConfigured = !string.IsNullOrEmpty(connectionString),

        ApiKeyConfigured = !string.IsNullOrEmpty(apiKey)
    });
});

app.MapGet("/api/health", () =>
{
    return Results.Ok(new
    {
        Health = health
    });
});
app.Run("http://0.0.0.0:8080");