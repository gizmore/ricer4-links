require 'spec_helper'

describe Ricer4::Plugins::Links do
  
  # LOAD
  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run
   
  LINKS = Ricer4::Plugins::Links::Model::Link

  it("can truncate table") do
    LINKS.cleardir
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{LINKS.table_name}")
  end

  it("can crawl messages for links and images") do
    # Dup via url
    bot.exec_line("https://www.wechall.net/news")
    expect(LINKS.count).to eq(1)
    bot.exec_line("https://www.wechall.net/news")
    expect(LINKS.count).to eq(1)
    # Dup via hash
    bot.exec_line("http://gizmore.org/?a")
    expect(LINKS.count).to eq(2)
    bot.exec_line("http://gizmore.org/?b")
    expect(LINKS.count).to eq(2)
    # Image with dup
    bot.exec_line("http://pooltool.gizmore.org/tpl/pt/img/banner.gif?a")
    expect(LINKS.count).to eq(3)
    bot.exec_line("http://pooltool.gizmore.org/tpl/pt/img/banner.gif?b")
    expect(LINKS.count).to eq(3)
  end

  it("can search and vote links") do
    bot.exec_line_for("Links/VoteUp", "1")
  end
  
end
