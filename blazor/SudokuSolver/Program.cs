
using Microsoft.AspNetCore.Blazor.Builder;
using Microsoft.AspNetCore.Blazor.Hosting;
using Microsoft.Extensions.DependencyInjection;

using SudokuSolver.Core;

namespace SudokuSolver
{
    public static class Program
    {
        public static void Main()
        {
            BlazorWebAssemblyHost.CreateDefaultBuilder()
                                 .UseBlazorStartup<Startup>()
                                 .Build()
                                 .Run();
        }

        public sealed class Startup
        {
            public void Configure(IBlazorApplicationBuilder app)
            {
                app.AddComponent<App>("app");
            }

            public void ConfigureServices(IServiceCollection services)
            {
                services.AddTransient(_ => Factory.EmptyGrid(3));
            }
        }
    }
}