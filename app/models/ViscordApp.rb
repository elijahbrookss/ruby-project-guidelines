class ViscordApp
    attr_reader :user, :channel

    def run
        display_intro
        user_input = login_prompt
        init_user(user_input)

        main_loop
    end

    private

    def main_loop
        prompt_entrance_menu
    end

    def prompt_entrance_menu
        puts "1) Your Channels\n2) Explore Channels"
        print "Input: "
        input = get_input

        case input
        when '1'
            messages = User.find(@user.id).messages
            channel_ids = messages.map{ |message| message.channel_id }.uniq             
            channels = channel_ids.map{ |channel_id| Channel.find(channel_id) }

            if channels
                question = "Choose a channel to join: "
                prompt = nil
                channel = prompt_user_messages(channels, question, prompt)
                @channel = channel[:message]
                channel_loop
            else
                puts "You don't have any channels. Go to explore channels to join one"
                prompt_entrance_menu
            end        
        when '2'
            channel_explore
        end

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
        print "Enter password: "
        input = get_input
        if input != @user.password then
            puts "Wrong password! Try again."
            password_entry
        end
        puts "Password accepted."
        sleep(1.5)
        load
    end

    def new_user_prompt
        puts "Hi #{@user.username}, welcome to Viscord"
        print "Create a new password for login: "
        input = get_input
        User.update(@user.id, password: input)
    end
    
    def display_messages
        Channel.find(@channel.id).display_messages
    end

    def get_input
        input = gets.chomp
        puts
        input
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
            message_id: message_id
        )
    end

    def channel_explore
        Channel.display_channels
        print "Choose a channel from the list: "
        input = get_input

        @channel = Channel.find_by(name: input)
        if !@channel then
            puts "#{input} isn't a valid channel name, try again!"
            channel_explore
        end
        channel_loop
    end

    def login_prompt
        print "Enter username: "
        input = get_input
    end

    def prompt_channel_loop
        display_messages
        puts "1) Enter a message\n2) React to a message\n3) Delete a message\n4) Edit a message\n5) exit channel"
        print "Input: "
    end
    
    def channel_loop
        input = true
        while input != '5' do
            prompt_channel_loop
            input = get_input
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

        main_loop
    end

    def edit_user_message
        prompt_user_message
    end

    def prompt_user_messages(messages = Message.where(user_id: @user.id), question, prompt)
        if messages.length > 0 then
            messages.each_with_index do |message, index|
                if message.class == Message then
                    puts "#{index+1}) #{message.content}"
                else
                    puts "#{index+1}) #{message.name}"
                end
            end

            print question
            input = get_input.to_i
            message = messages[input-1]

            if message then
                if prompt then
                    print prompt
                    input = get_input
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
        hash = prompt_user_messages(nil, question, prompt)
        if hash then
            update(hash[:message.id], hash[:input] )
        end
    end

    def prompt_user_delete
        question = "Which message would you like to delete?: "
        prompt = nil
        hash = prompt_user_messages(nil, question, prompt)
        if hash then
            delete(hash[:message])
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
        print "Type a message and press enter to send: "
        input = get_input
        Message.create(
            content: input, 
            user_id: @user.id, 
            channel_id: @channel.id
        )
    end

    def display_intro  
        puts "VISCORD" #=> Make a creative text later
        puts "Loading App" #=> Make a more creative loading screen
        load
    end

    def load
        10.times do |t|
            print "."
            sleep(0.2)
        end
        puts
    end

end
