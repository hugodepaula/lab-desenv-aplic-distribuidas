package com.example.demo.docker.compose.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.docker.compose.model.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
}