<x-layout>
    <x-slot name="title">Users List</x-slot>
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Users Management</h1>
        <a href="{{ route('users.create') }}" class="btn btn-primary">Add New User</a>
    </div>

    @if($users->count() > 0)
        @foreach($users as $user)
            <x-user-card :user="$user" />
        @endforeach
    @else
        <div class="alert alert-info">
            <h4>No Users Found</h4>
            <p>There are no users in the system. <a href="{{ route('users.create') }}">Create one now</a>.</p>
        </div>
    @endif
</x-layout>