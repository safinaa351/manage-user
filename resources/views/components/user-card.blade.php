<div class="card mb-3">
    <div class="card-body">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h5 class="card-title mb-1">{{ $user->name }}</h5>
                <p class="card-text mb-1">
                    <small class="text-muted">{{ $user->email }} | {{ $user->phone }}</small>
                </p>
                <p class="card-text mb-1">
                    <span class="badge bg-secondary">{{ $user->department }}</span>
                    <span class="badge {{ $user->is_active ? 'bg-success' : 'bg-danger' }}">
                        {{ $user->is_active ? 'Active' : 'Inactive' }}
                    </span>
                </p>
            </div>
            <div class="col-md-4 text-end">
                <a href="{{ route('users.edit', $user->id) }}" class="btn btn-sm btn-outline-primary">Edit</a>
                <form action="{{ route('users.destroy', $user->id) }}" method="POST" class="d-inline" 
                      onsubmit="return confirm('Are you sure you want to delete this user?')">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>