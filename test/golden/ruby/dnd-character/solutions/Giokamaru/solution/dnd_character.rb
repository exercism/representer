class DndCharacter
  # Lista de atributos de un personaje y valores permitidos para tiradas de dados
  ATTRS = %i[strength dexterity constitution intelligence wisdom charisma].freeze
  ROLLS = (1..6).to_a.freeze
  
  # Atributos de solo lectura para cada habilidad
  attr_reader *ATTRS
  
  # Método de clase para calcular el modificador basado en el valor de una habilidad
  def self.modifier(value)
    case value
    when 3 then -4
    when 4..5 then -3
    when 6..7 then -2
    when 8..9 then -1
    when 10..11 then 0
    when 12..13 then 1
    when 14..15 then 2
    when 16..17 then 3
    else 4
    end
  end
  
  # Método constructor
  def initialize
    # Genera valores aleatorios para cada habilidad al inicializar un nuevo personaje
    ATTRS.each { |attr| instance_variable_set("@#{attr}", roll_attr) }
  end
  
  # Método para calcular los puntos de golpe iniciales del personaje
  def hitpoints
    10 + self.class.modifier(constitution)
  end
  
  private
  
  # Método para simular la tirada de dados y calcular el valor de una habilidad
  def roll_attr
    # Realiza 4 tiradas de dados, las mezcla y selecciona las 3 mayores
    4.times.map { ROLLS.shuffle.sample }
      .sort.reverse
      .take(3).sum
  end
end
