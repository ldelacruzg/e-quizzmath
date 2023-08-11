import 'package:e_quizzmath/config/menu/menu_item.dart';
import 'package:flutter/material.dart';

final appMenu = [
  const MenuItem(
    title: 'Inicio',
    subtitle: 'Página principal',
    icon: Icons.home_outlined,
    link: '/',
  ),
  const MenuItem(
    title: 'Temas',
    subtitle: 'Lista de temas',
    icon: Icons.grid_view_outlined,
    link: '/topics',
  ),
  const MenuItem(
    title: 'Clasificación',
    subtitle: 'Tabla de clasificación',
    icon: Icons.leaderboard_outlined,
    link: '/leaderboard',
  ),
  const MenuItem(
    title: 'Perfil',
    subtitle: 'Información del usuario',
    icon: Icons.person_outlined,
    link: '/profile',
  ),
];
