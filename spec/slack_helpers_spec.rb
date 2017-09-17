require 'hashie'

describe SlackHelpers, '.member_name' do
  it 'returns a real name if possible' do
    member = Hashie::Mash.new(profile: { real_name: 'Bob Loblaw' }, name: 'bob')
    expect(SlackHelpers.member_name(member)).to eq('Bob Loblaw')
  end

  it 'falls back to regular name' do
    member = Hashie::Mash.new(profile: { real_name: '' }, name: 'bob')
    expect(SlackHelpers.member_name(member)).to eq('bob')
  end
end

describe SlackHelpers, '.channel_members' do
  it 'sorts by first name' do
    slack = instance_double('Slack::Web::Client')
    expect(slack).to receive(:users_list).and_return(
      Hashie::Mash.new(
        members: [
          { id: 1, name: 'gob', deleted: false, is_bot: false, profile: { real_name: 'George Oscar Bluth' } },
          { id: 2, name: 'bob', deleted: false, is_bot: false, profile: { real_name: 'Bob Loblaw' } },
        ]
      )
    )
    expect(slack).to receive(:channels_info).with(channel: '#ad').and_return(
      Hashie::Mash.new(channel: { members: [1, 2] })
    )
    expect(SlackHelpers.channel_members(slack, 'ad').map(&:name)).to eq(['bob', 'gob'])
  end

  it 'does not include bot users' do
    slack = instance_double('Slack::Web::Client')
    expect(slack).to receive(:users_list).and_return(
      Hashie::Mash.new(
        members: [
          { id: 1, name: 'gob', deleted: false, is_bot: false, profile: { real_name: 'George Oscar Bluth' } },
          { id: 2, name: 'franklin', deleted: false, is_bot: true, profile: { real_name: '' } },
        ]
      )
    )
    expect(slack).to receive(:channels_info).with(channel: '#ad').and_return(
      Hashie::Mash.new(channel: { members: [1, 2] })
    )
    expect(SlackHelpers.channel_members(slack, 'ad').map(&:name)).to eq(['gob'])
  end

  it 'does not include deleted users' do
    slack = instance_double('Slack::Web::Client')
    expect(slack).to receive(:users_list).and_return(
      Hashie::Mash.new(
        members: [
          { id: 1, name: 'gob', deleted: false, is_bot: false, profile: { real_name: 'George Oscar Bluth' } },
          { id: 2, name: 'kitty', deleted: true, is_bot: false, profile: { real_name: '' } },
        ]
      )
    )
    expect(slack).to receive(:channels_info).with(channel: '#ad').and_return(
      Hashie::Mash.new(channel: { members: [1, 2] })
    )
    expect(SlackHelpers.channel_members(slack, 'ad').map(&:name)).to eq(['gob'])
  end
end
