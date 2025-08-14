<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

Route::get('/', function () {
    return view('welcome');
});

// Web Routes untuk interface
Route::prefix('users')->name('users.')->group(function () {
    Route::get('/', [UserController::class, 'webIndex'])->name('index');
    Route::get('/create', [UserController::class, 'create'])->name('create');
    Route::post('/', [UserController::class, 'webStore'])->name('store');
    Route::get('/{id}/edit', [UserController::class, 'edit'])->name('edit');
    Route::put('/{id}', [UserController::class, 'webUpdate'])->name('update');
    Route::delete('/{id}', [UserController::class, 'webDestroy'])->name('destroy');
});