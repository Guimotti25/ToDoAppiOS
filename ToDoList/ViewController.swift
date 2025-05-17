//
//  ViewController.swift
//  ToDoList
//
//  Created by Guilherme Motti on 17/05/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewDados: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listaTarefas: [Tarefa] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableViewDados.dataSource = self
        self.tableViewDados.delegate = self
        
        self.obterTarefas()
    }
    
    private func obterTarefas()
    {
       //Lista obtida abaixo
        do {
            self.listaTarefas = try context.fetch(Tarefa.fetchRequest())
            DispatchQueue.main.async {
                self.tableViewDados.reloadData()
            }
        }
        catch {
            
        }
    }
    


    @IBAction func botaoAdicionarPressionado(_ sender: Any)
    {
        // Exibir Alerta com  editText
        self.exibirAlerta()
    }
    
    private func exibirAlerta()
    {
        let alert = UIAlertController(title: "Adicionar Item", message: "Digite o texto abaixo", preferredStyle: .alert)
             
             // Adiciona um text field ao alerta
             alert.addTextField { (textField) in
                 textField.placeholder = "Digite aqui"
             }
             
             // Cria o botão Cancelar
             let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
             
             // Cria o botão Adicionar
             let addAction = UIAlertAction(title: "Adicionar", style: .default) { [weak self, weak alert] _ in
                 guard let textField = alert?.textFields?.first, let text = textField.text else { return }
                 // Aqui você pode usar o texto digitado
                 print("Texto digitado: \(text)")
                 self?.handleAddAction(text: text)
             }
             
             // Adiciona os botões ao alerta
             alert.addAction(cancelAction)
             alert.addAction(addAction)
             
             // Exibe o alerta
             present(alert, animated: true, completion: nil)
     }
    
    private func handleAddAction(text: String) {
         // Função para tratar o que acontece quando o usuário clica em Adicionar
         print("Item adicionado: \(text)")
         // Aqui você pode adicionar a lógica para salvar ou processar o texto
        let novaTarefa = Tarefa(context: self.context)
        novaTarefa.tarefa = text
        
        do {
            try self.context.save()
        }catch {
            
        }
        
        self.obterTarefas()
     }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listaTarefas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celula = tableView.dequeueReusableCell(withIdentifier: "TarefasCell", for: indexPath)
        
        celula.textLabel?.text = self.listaTarefas[indexPath.row].tarefa
        
        return celula
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}

