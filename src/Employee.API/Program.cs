var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddOpenApi();

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
        Message = "Welcome to Cloud Employee Management Platform (CEMP)"
    });
});

app.MapGet("/api/config", () =>
{
    return Results.Ok(new
    {
        ApplicationName = "Cloud Employee Management Platform",
        Environment = "Development",
        ApiUrl = "http://backend-service"
    });
});

//app.Run();
app.Run("http://0.0.0.0:8080");