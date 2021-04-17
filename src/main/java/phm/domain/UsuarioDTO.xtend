package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class UsuarioDTO {
  Long id
  String username

  private new() {}

  def static fromUsuario(Usuario usuario) {
    new UsuarioDTO => [
      id = usuario.id
      username = usuario.username
    ]
  }
}