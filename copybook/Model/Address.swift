
import Foundation

struct Address: Codable {
    let cep, logradouro, complemento, bairro: String
    let localidade, uf, ibge, gia: String
    let ddd, siafi: String
}
