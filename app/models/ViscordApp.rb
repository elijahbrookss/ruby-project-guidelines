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
        channel_prompt
        channel_loop
    end

    def init_user(input)
        @user = User.find_by(username: input)
        if @user then
            puts "You have an account, lead to passwords"
        else
            puts "You don't have an account"
        end

        # @user = User.find_or_create_by(username: input)
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

    def channel_prompt
        Channel.display_channels
        print "Choose a channel from the list: "
        input = get_input

        @channel = Channel.find_by(name: input)
        if !@channel then
            puts "#{input} isn't a valid channel name, try again!"
            channel_prompt
        end
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
                puts "#{index+1}) #{message.content}"
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
            puts "Silly, you don't have any messages. Create some messages!"
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
        10.times do |t|
            print "."
            sleep(0.2)
        end
        puts
    end
end
