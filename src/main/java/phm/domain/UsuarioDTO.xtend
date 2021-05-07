package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Set

@Accessors
class UsuarioDTO {
  Long id
  String username
  Set<RegistroRespuestas> historial

  private new() {}

  def static fromUsuario(Usuario usuario) {
    new UsuarioDTO => [
      id = usuario.id
      username = usuario.username
      historial = usuario.historial
    ]
  }
}