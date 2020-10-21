class ViscordApp

    PROMPT = TTY::Prompt.new

    attr_reader :user, :channel

    def run
        display_intro
        user_input = login_prompt
        init_user(user_input)

        main_loop
    end

    private

    def main_loop
        system("clear")
        prompt_entrance_menu
    end

    def prompt_entrance_menu
        puts "1) Your Channels\n2) Explore Channels\n3) Logout"
        input = get_input

        logout = false

        case input
        when '1'
            messages = User.find(@user.id).messages
            channel_ids = messages.map{ |message| message.channel_id }.uniq             
            channels = channel_ids.map{ |channel_id| Channel.find(channel_id) }

            if channels.length > 0
                question = "Choose a channel to join: "
                prompt = nil
                channel = prompt_user_messages(channels, question, prompt)
                if channel then
                    @channel = channel[:message]
                    channel_loop
                end
            else
                puts "You don't have any channels. Go to explore channels to join one\n\n"
                main_loop

                return
            end        
        when '2'
            channel_explore
        when '3'
            logout = true
        end
        if !logout then
            main_loop

            return
        end
        system("clear")
        puts "
        
        
        
        
        "
        load
        puts "Thanks #{@user.username} come again!"
    end

    def init_user(input)
        @user = User.find_by(username: input)
        if @user then
            password_prompt
        else
            @user = User.create(username: input)
            new_user_prompt
        end
    end

    def password_prompt
        puts "Welcome back, #{@user.username}, just enter your password and you'll be ready to go!"
        password_entry
    end

    def password_entry
        input = PROMPT.mask("Enter password: ")
        if input != @user.password then
            puts "Wrong password! Try again."
            password_entry

            return
        end
        puts "Password accepted"
        sleep(1.5)
        system("clear")
        puts "
        
        
        
        
        "
        load
    end

    def new_user_prompt
        puts "Hi #{@user.username}, welcome to Viscord"
        input = PROMPT.mask("Create a new password for login: ")
        User.update(@user.id, password: input)
    end
    
    def display_messages
        system("clear")
        Channel.find(@channel.id).display_messages
    end

    def get_input(question = "Input: ")
        input = PROMPT.ask(question)
    end
    
    def delete_user_message
        prompt_user_delete
    end

    def update(message_id, input)
        Message.update(message_id, content: input)
    end

    def delete(message_id)
        Message.delete(message_id)
    end

    def react_to_message
        display_react_menu
    end

    def create_reaction(message_id, input)
        Reaction.create(
            user_id: @user.id, 
            emoji: input, 
            message_id: message_id.id
        )
    end

    def prompt_user_make_channel
        input = PROMPT.ask("Channel name:")
    end

    def get_channel_from_input(input)
        channels = Channel.all
        if input == channels.length+1 then
            input = prompt_user_make_channel
            new_channel = Channel.create(name: input)
            return new_channel
        end
        channel = channels[input.to_i]
        if channel then
            return channel
        end
        return nil
    end

    def channel_explore
        input = Channel.display_channels
        @channel = Channel.find_by(name: input) || get_channel_from_input(input)
        if !@channel then
            if input == Channel.all.length+2 then
                return
            end
            channel_explore
            return
        end
        channel_loop
    end

    def login_prompt
        input = get_input("Enter username: ")
    end

    def prompt_channel_loop
        display_messages

        PROMPT.select("") do |menu|
            menu.choice "Enter a message", '1'
            menu.choice "React to a message", '2'
            menu.choice "Delete a message", '3'
            menu.choice "Edit a message", '4'
            menu.choice "Exit channel", '5'
        end
    end
    
    def channel_loop
        input = true
        while input != '5' do
            input = prompt_channel_loop
            case input
            when "1"
                make_new_message
            when "2"
                react_to_message
            when "3"
                delete_user_message
            when "4"
                edit_user_message
            end
        end
    end

    def edit_user_message
        prompt_user_message
    end

    def prompt_user_messages(messages = Message.where(user_id: @user.id), question, prompt)
        choices = {}

        if messages.length > 0 then
            messages.each_with_index do |message, index|
                if message.class == Message then
                    value = "#{message.content}"
                else
                    value = "#{message.name}"
                end

                choices[value] = index + 1
            end


            input = PROMPT.select(question, choices)

            message = messages[input-1]

            if message then
                if prompt then
                    
                    input = PROMPT.ask(prompt)
                end
                return {message: message, input: input}
            else
                puts "Not a valid choice."
                sleep(1.5)
                nil
            end
        else
            puts "Not a valid choice."
        end    
    end

    def prompt_user_message
        question = "Which message would you like to edit?: "
        prompt = "Type your edit: "
        hash = prompt_user_messages(question = question, prompt = prompt)
        if hash then
            update(hash[:message].id, hash[:input] )
        end
    end

    def prompt_user_delete
        question = "Which message would you like to delete?: "
        prompt = nil
        hash = prompt_user_messages(question = question, prompt = prompt)
        if hash then
            delete(hash[:message].id)
        end
    end

    def display_react_menu
        question = "Which message would you like to react to?: "
        prompt = "How do you want to react?: "
        messages = Channel.find(channel.id).messages
        hash = prompt_user_messages(messages, question, prompt)

        if hash then
            create_reaction(hash[:message], hash[:input])
        end
    end

    def make_new_message
        question =  "Type a message and press enter to send: "
        input = PROMPT.ask(question)
        Message.create(
            content: input, 
            user_id: @user.id, 
            channel_id: @channel.id
        )
    end

    def display_intro
        system("clear")
        puts "
                                                                                      
                ▀████▀   ▀███▀████▀▄█▀▀▀█▄█ ▄▄█▀▀▀█▄█ ▄▄█▀▀██▄ ▀███▀▀▀██▄ ▀███▀▀▀██▄  
                  ▀██     ▄█   ██ ▄██    ▀███▀     ▀███▀    ▀██▄ ██   ▀██▄  ██    ▀██▄
                   ██▄   ▄█    ██ ▀███▄   ██▀       ▀█▀      ▀██ ██   ▄██   ██     ▀██
                    ██▄  █▀    ██   ▀█████▄█        ██        ██ ███████    ██      ██
                    ▀██ █▀     ██ ▄     ▀███▄       ██▄      ▄██ ██  ██▄    ██     ▄██
                     ▄██▄      ██ ██     ████▄     ▄▀██▄    ▄██▀ ██   ▀██▄  ██    ▄██▀
                      ██     ▄████▄▀█████▀  ▀▀█████▀  ▀▀████▀▀ ▄████▄ ▄███▄████████▀  
                                                                                      
                                                                                      

                                                                                    
        ".magenta

        PROMPT.keypress
        system("clear")
        puts "
  
                                                      ▄▄   ▄▄                     
                    ▀████▀                          ▀███   ██                     
                      ██                              ██                          
                      ██       ▄██▀██▄ ▄█▀██▄    ▄█▀▀███ ▀███ ▀████████▄  ▄█▀█████
                      ██      ██▀   ▀███   ██  ▄██    ██   ██   ██    ██ ▄██  ██  
                      ██     ▄██     ██▄█████  ███    ██   ██   ██    ██ ▀█████▀  
                      ██    ▄███▄   ▄███   ██  ▀██    ██   ██   ██    ██ ██       
                    ██████████ ▀█████▀▀████▀██▄ ▀████▀███▄████▄████  ████▄███████ 
                                                                         █▀     ██
                                                                         ██████▀  


        ".magenta
        load
    end

    def load
        print"              o".magenta
        12.times do |t|
            print"     o".magenta
           sleep(rand(0.1 .. 0.6))
        end
        puts
        system("clear")

    end

end
