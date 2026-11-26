public class Orm(Database database) : IDisposable
{
    private readonly Database _database = database;
    private bool _disposed = false;

    public void Begin() => ExecuteDatabaseCall(_database.BeginTransaction);

    public void Write(string data) => ExecuteDatabaseCall(() => _database.Write(data));

    public void Commit() => ExecuteDatabaseCall(_database.EndTransaction);

    private void ExecuteDatabaseCall(Action dbAction)
    {
        try
        {
            dbAction();
        }
        catch (InvalidOperationException)
        {
            Dispose();
        }
    }

    protected virtual void Dispose(bool disposing)
    {
        if (!_disposed)
        {
            if (disposing)
            {
                _database.Dispose();
            }

            _disposed = true;
        }
    }

    public void Dispose()
    {
        Dispose(disposing: true);
        GC.SuppressFinalize(this);
    }

}
