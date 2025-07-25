<?php

namespace App\Http\Controllers\authentications;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\UserService; // 1. Importe o seu novo Service

class RegisterBasic extends Controller
{
  public function index()
  {
    return view('content.authentications.auth-register-basic');
  }

  public function store(Request $request, UserService $userService)
  {
    $validatedData = $request->validate([
      'name'     => 'required|string|max:255',
      'email'    => 'required|email|unique:users,email',
      'password' => 'required|string|min:6|confirmed',
    ]);

    $userService->createUser($validatedData);

    return redirect()->route('login')->with('success', 'Usuário registrado com sucesso!');
  }
}