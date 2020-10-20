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
        User.find_or_create_by(username: input)
    end


    def display_messages
        Channel.find(@channel.id).display_messages
    end

    def get_input
        input = gets.chomp
        puts
        input
    end
    
    def channel_prompt
        puts "Choose a channel from the list: "
        Channel.display_channels
        input = get_input

        @channel = Channel.find(input.to_i)
    end


    def login_prompt
        print "Enter username: "
        input = get_input
    end

    def channel_loop
        input = true
        while input != '5' do
            display_messages
            puts "1) Enter a message\n2) React to a message\n3) Delete a message\n4) Edit a message\n5) exit channel"
            print "Input: "
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

    def prompt_user_message
        messages = Message.where(user_id: @user.id)
        if messages.length > 0 then
            messages.each_with_index do |message, index|
                puts "#{index+1}) #{message.content}"
            end
            print "Which message would you like to edit?: "
            input = get_input.to_i
            message = messages[input-1]
            print "Type your edit: "
            input = get_input

            if message then
                Message.update(message.id, content: input)
            end
        else
            puts "Silly, you don't have any messages. Create some messages!"
        end       
    end



    def delete_user_message
        prompt_user_delete
    end

    def prompt_user_delete
        messages = Message.where(user_id: @user.id)
        if messages.length > 0 then
            messages.each_with_index do |message, index|
                puts "#{index+1}) #{message.content}"
            end
            print "Which message would you like to delete?: "
            input = get_input.to_i
            message = messages[input-1]

            if message then
                Message.destroy(message.id)
            end
        else
            puts "Silly, you don't have any messages. Create some messages!"
        end

    end

    def make_new_message
        print "Type a message and press enter to send: "
        input = get_input
        Message.create(content: input, user_id: @user.id, channel_id: @channel.id)
    end
    
    def react_to_message
        display_react_menu
    end

    def display_react_menu
        messages = Channel.find(channel.id).messages
        messages.each_with_index do |message, index|
            puts "#{index+1}) #{message.content}"
        end
        print "Which message would you like to react to?: "
        input = get_input.to_i

        message = messages[input-1]
        print "How do you want to react?: "
        input = get_input

        if message then
            Reaction.create(user_id: @user.id, emoji: input, message_id: message.id)
        else
            puts "Sorry, message choice not found."
        end
    end

    def display_intro  
        puts "VISCORD" #=> Make a creative text later
        puts "Loading App" #=> Make a more creative loading screen
        5.times do |t|
            print "."
            sleep(0.5)
        end
        puts
    end

end
