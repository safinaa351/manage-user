<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

Route::get('/', function () {
    return view('welcome');
});

// Web Routes untuk interface
Route::prefix('users')->name('users.')->group(function () {
    Route::get('/', [UserController::class, 'webIndex'])->name('index');
    Route::get('/create', [UserController::class, 'create'])->name('create'); //show the page where user can do create
    Route::post('/', [UserController::class, 'webStore'])->name('store'); // do the create
    Route::get('/{id}/edit', [UserController::class, 'edit'])->name('edit'); //show the page where user can do update
    Route::put('/{id}', [UserController::class, 'webUpdate'])->name('update'); //do the update
    Route::delete('/{id}', [UserController::class, 'webDestroy'])->name('destroy');
});