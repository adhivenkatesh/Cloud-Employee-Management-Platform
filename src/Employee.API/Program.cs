var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddOpenApi();

var appName = Environment.GetEnvironmentVariable("APP_NAME");
var version = Environment.GetEnvironmentVariable("APP_VERSION");
var company = Environment.GetEnvironmentVariable("COMPANY_NAME");

var dbUser = Environment.GetEnvironmentVariable("DB_USERNAME");
var dbPassword = Environment.GetEnvironmentVariable("DB_PASSWORD");
var apiKey = Environment.GetEnvironmentVariable("API_KEY");

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

// Later, when with Ingress, TLS, and NGINX, we'll enable HTTPS properly.
//app.UseHttpsRedirection();

app.MapGet("/", () =>
{
    return Results.Ok(new
    {
        Message = $"Welcome to {appName}",
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

        DatabaseUser = dbUser,
        DatabasePassword = dbPassword,
        ApiKey = apiKey
    });
});

//app.Run();
app.Run("http://0.0.0.0:8080");