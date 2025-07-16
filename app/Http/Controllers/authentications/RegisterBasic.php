<?php

namespace App\Http\Controllers\authentications;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class RegisterBasic extends Controller
{
  public function index()
  {
    return view('content.authentications.auth-register-basic');
  }

  public function store(Request $request)
  {
    $request->validate([
      'name'     => 'required|string|max:255',
      'email'    => 'required|email|unique:users,email',
      'password' => 'required|string|min:6|confirmed', // precisa do campo password_confirmation
    ]);

    User::create([
      'name'     => $request->name,
      'email'    => $request->email,
      'password' => $request->password, // Laravel vai hashear automaticamente
    ]);

    return redirect()->route('auth-login-basic')->with('success', 'Usuário registrado com sucesso!');
  }
}