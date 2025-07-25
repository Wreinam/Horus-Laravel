<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\dashboard\Analytics;
use App\Http\Controllers\authentications\LoginBasic;
use App\Http\Controllers\authentications\RegisterBasic;
use App\Http\Controllers\authentications\ForgotPasswordBasic;
use App\Http\Controllers\tables\Basic as TablesBasic;


Route::middleware('auth')->group(function () {
    Route::get('/dashboard', [Analytics::class, 'index'])->name('dashboard-analytics');
    // outras rotas protegidas
});

// Authentication Page Route
Route::get('/', [LoginBasic::class, 'index'])->name('login');
Route::get('/login', [LoginBasic::class, 'index'])->name('login');
Route::get('/register', [RegisterBasic::class, 'index'])->name('register');
Route::get('/forgot-password', [ForgotPasswordBasic::class, 'index'])->name('reset-password');

Route::post('/register', [RegisterBasic::class, 'store'])->name('register.store');
Route::post('/login', [LoginBasic::class, 'login'])->name('login.store');

// tables
Route::get('/tables/basic', [TablesBasic::class, 'index'])->name('tables-basic');