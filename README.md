
# MultiAPI Store (Flutter) – Diego Gonzalez

Proyecto académico **(Desarrollo de Software y Programación)** que consume **múltiples APIs** y guarda datos en el **STORE** de la app con **Riverpod** y **SharedPreferences**. Incluye **paginación**, **búsqueda** y **tema claro/oscuro** persistente.

## Autor
- **Nombre:** diego gonzalez
- **Carrera:** Desarrollo de Software y Programación

## Tecnologías
- Flutter 3 (Dart 3)
- flutter_riverpod 2.x
- http 1.x
- shared_preferences 2.x

## APIs
- JSONPlaceholder (posts): https://jsonplaceholder.typicode.com
- Rick & Morty (characters): https://rickandmortyapi.com/

## Cómo ejecutar
1. Instala Flutter: https://flutter.dev/docs/get-started/install
2. Descomprime el ZIP en una carpeta (p. ej. `Documentos/Proyectos/`).
3. Abre la carpeta `multiapi-store-flutter-diego-gonzalez` en **Visual Studio Code**.
4. En la terminal, ejecuta:
   ```bash
   flutter create .    # genera android/ios/web si no existen
   flutter pub get
   flutter run         # selecciona un dispositivo/emulador
   ```

## Subir a GitHub
```bash
git init
git add .
git commit -m "feat: Flutter multi API + Riverpod + persist (by diego gonzalez)"
git branch -M main
git remote add origin https://github.com/<tu-usuario>/multiapi-store-flutter-diego-gonzalez.git
git push -u origin main
```

## Qué verás
- Lista combinada de **Posts** + **Personajes**, alternados.
- **Favoritos** con persistencia.
- **Búsqueda** por título/nombre.
- **Paginación** (siguiente/anterior página de personajes).
- **Tema claro/oscuro** con persistencia.
