using Microsoft.EntityFrameworkCore;
using TendonLoaderApi.Models;

namespace TendonLoaderApi.Data;

public partial class TendonLoaderContext : DbContext
{
    public TendonLoaderContext() {}

    public TendonLoaderContext(DbContextOptions<TendonLoaderContext> options) : base(options) {}

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<Exercise> Exercises { get; set; }

    public virtual DbSet<Prescription> Prescriptions { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlite("Name=TendonLoader");

    public DbSet<TendonLoaderApi.Models.Settings> Settings { get; set; } = default!;
}
