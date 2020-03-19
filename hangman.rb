require "yaml"

$dictionary = File.open('5desk.txt','r')
$lines = $dictionary.readlines

class Hangman
  
  def initialize
    @word = $lines[rand(1..$lines.length)].downcase
    @compare = @word.dup.downcase
    @count = 0
    @max = 6
    @length = @word.length
    quantity = @length - rand(@word.length/2)
    quantity.times do
    random = rand(@length)
    @word[random] = "_"
    end
    puts @word
    looping
   
  end
 
 
 
  def input
     puts "letter please? S-save, L-load"
    @letter = gets.chomp
    save_me if @letter == "S" 
    load_me if @letter == "L"
    while !@letter.match(/[a-z]/) || @letter.length != 1
      puts "Hmm seems like you inputted a invalid input or a longer value"
      @letter = gets.chomp
    end
  end
 
  def update
    if @compare.include?(@letter)
    @compare.chars.each_with_index do |lets,indi|
      @word[indi] = @letter if lets == @letter
    end
    puts @word
  else 
    @count += 1
    puts "None, You have #{@max - @count} tries left"
  end
  
  end

  def game_over?
    
    if @count == 6 || @word == @compare 
      puts @compare 
      return true
    else 
      return false 
    end 
  end
    
  def looping 
    loop do 
      input 
      update 
      break if game_over?
    end
  end

  def save_me 
    puts "enter the name you wanna save the game as"
    filename = gets.chomp + ".yml"
    Dir.mkdir('data') unless Dir.exist?('data')
    unless File.exist?("data/#{filename}")
    to_write = File.new("data/#{filename}","w") 
    else 
    puts "file already exists"
    save_me
    
    end


    serialized = YAML.dump({
     word: @word, 
     length: @length,
     compare: @compare, 
     count: @count

    })
    to_write.puts(serialized)
    sleep(3)
    exit







  end

  def load_me 
  puts "enter the name of the file you wana load"
  filename = gets.chomp + ".yml"
  unless !File.exist?("data/#{filename}")
  to_read = File.open("data/#{filename}","r")
  else 
  puts "File doesnt exist"
  load_me 
  end 
  
  data = YAML.load File.read(to_read)
  @word = data[:word]
  @compare = data[:compare]
  @length  = data[:length]
  @count  = data[:count]
  puts "Loading game"
  puts @word
  sleep(5)
  end  
end
 
game = Hangman.new

