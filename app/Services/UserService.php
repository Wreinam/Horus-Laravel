<?php

namespace App\Services;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserService
{
  public function createUser(array $data): User
  {
    return User::create([
      'name'     => $data['name'],
      'email'    => $data['email'],
      'password' => Hash::make($data['password']),
    ]);
  }
}