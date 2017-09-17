module SlackHelpers
  def self.member_name(member)
    if member.profile.real_name.empty?
      member.name
    else
      member.profile.real_name
    end
  end

  def self.channel_members(client, channel)
    users = client.users_list
    channel_info = client.channels_info(channel: "##{channel}")
    channel_info.channel.members.map do |id|
      users.members.detect { |user| user.id == id }
    end.reject do |member|
      member.deleted || member.is_bot
    end.sort_by do |member|
      member_name(member).downcase
    end
  end
end
