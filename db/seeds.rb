# Seeds are idempotent — safe to re-run at any time.
# Create the single admin user (Isara) from ENV vars.
#
# Usage:
#   USER_EMAIL="isara@example.com" USER_PASSWORD="securepassword" USER_NAME="Dr Isara Khanjanasthiti" rails db:seed
#
# Defaults are set for local dev only — never deploy without real ENV vars.

email    = ENV.fetch("USER_EMAIL", "admin@example.com")
password = ENV.fetch("USER_PASSWORD", "password123!")
name     = ENV.fetch("USER_NAME", "Dr Isara Khanjanasthiti")

if User.exists?(email: email)
  puts "Seed: user #{email} already exists, skipping."
else
  User.create!(
    email: email,
    password: password,
    password_confirmation: password,
    name: name
  )
  puts "Seed: created user #{email} (#{name})."
end

user = User.find_by!(email: email)

# ===== BLOG POSTS =====
puts "Seeding blog posts..."

blog_posts_data = [
  {
    title: "Cross-Border Planning Around Gold Coast Airport: Lessons for Regional Governance",
    blog_excerpt: "Airport-driven development rarely respects administrative boundaries — my doctoral research explores how Gold Coast Airport has reshaped regional planning across the Queensland–NSW border.",
    body_html: "<h2>The Challenge of Jurisdictional Overlap</h2><p>Aviation infrastructure does not conform to state borders, yet planning policy in Australia remains stubbornly jurisdictional. My doctoral research examined how Gold Coast Airport — straddling the Queensland–New South Wales boundary — has created a complex governance landscape that neither state is fully equipped to manage alone.</p><h2>Key Findings</h2><p>The case study revealed three recurring tensions: economic competition between councils, inconsistent land-use zoning on either side of the border, and a near-total absence of formal intergovernmental coordination mechanisms. Businesses, residents, and developers are left navigating two regulatory regimes for what is, functionally, a single urban precinct.</p><h2>Implications for Australian Planning</h2><p>If Australia is serious about unlocking the economic potential of secondary airports — and the federal government's regional aviation policy suggests it is — we need to develop cross-border governance frameworks that match the spatial reality of airport-driven growth. The Gold Coast case offers both cautionary lessons and a roadmap for what coordinated planning could look like.</p>",
    status: :published,
    ai_generated: false,
    created_at: 3.months.ago
  },
  {
    title: "Housing Affordability in Sydney: Why Urban Planners Must Lead the Conversation",
    blog_excerpt: "Sydney's housing crisis is as much a planning failure as it is a market failure. I argue that urban planners have both the tools and the professional obligation to drive meaningful reform.",
    body_html: "<h2>A Crisis Hiding in Plain Sight</h2><p>Sydney's median house price-to-income ratio now sits above 13 — a figure that would have seemed absurd to planners in the 1980s. Yet in many policy circles, housing affordability is still treated as primarily a market problem, with planning cast in a supporting role at best.</p><h2>The Planning Dimension</h2><p>Zoning restrictions, heritage overlays, development contribution frameworks, and slow assessment timelines all act as supply-side constraints that compound affordability pressures. These are not market failures — they are planning failures, and they require planning solutions.</p><h2>What Needs to Change</h2><p>Evidence from international comparisons — particularly Tokyo's relatively liberalised zoning and Vienna's social housing model — suggests that planning systems can and do shape housing outcomes at scale. Australian jurisdictions need to seriously examine minimum dwelling sizes, transit-oriented density uplift, and the role of inclusionary zoning as mechanisms for delivering affordable supply.</p>",
    status: :published,
    ai_generated: false,
    created_at: 2.months.ago
  },
  {
    title: "Rethinking Assessment in Urban Planning Education: Moving Beyond the Final Report",
    blog_excerpt: "Traditional planning studios culminate in thick final reports that few practitioners ever read. I've been experimenting with assessment formats that better reflect how planners actually communicate in practice.",
    body_html: "<h2>The Problem with the 5,000-Word Report</h2><p>Ask any practising urban planner how often they submit a 5,000-word written report in their day-to-day work. The answer, almost universally, is: never. Yet this remains the dominant assessment format in Australian planning schools, including at undergraduate level where students are still forming their professional identity.</p><h2>What Practitioners Actually Do</h2><p>Planners present to councils, brief ministers, facilitate community engagement workshops, respond to submissions, and prepare development assessment reports — none of which map neatly onto a traditional academic essay. Our assessment design should reflect this.</p><h2>Alternatives Worth Trialling</h2><p>In my recent studio units, I have experimented with oral examinations, policy briefing notes, community consultation simulations, and peer-assessed design charrettes. The results have been encouraging: students engage more deeply with content when the output format feels professionally authentic. The challenge now is convincing assessment committees that rigour and real-world relevance are not mutually exclusive.</p>",
    status: :published,
    ai_generated: false,
    created_at: 6.weeks.ago
  },
  {
    title: "Second-Tier Airports and Regional Economic Development: A Literature Review",
    blog_excerpt: "What does the research actually say about whether airports generate the economic growth governments promise? A review of the evidence — and why the picture is more nuanced than most airport proponents admit.",
    body_html: "<h2>The Aviation-Growth Thesis</h2><p>Airports are frequently positioned by governments and lobby groups as engines of regional economic development — catalysts for tourism, logistics, and business investment. This narrative is politically compelling, but the empirical evidence is considerably more mixed.</p><h2>What the Literature Finds</h2><p>Meta-analyses of airport economic impact studies consistently show that projections made by airport proponents overstate induced employment and business activity, often by a factor of two or three. The causal direction also remains contested: airports may grow because regions grow, rather than the other way around.</p><h2>The Second-Tier Case</h2><p>Secondary airports — those outside major metropolitan gateways — face a particularly challenging evidence base. While some, like Gold Coast and Avalon, have demonstrated genuine catalytic effects in specific niches (low-cost carrier markets, aerospace maintenance), the conditions enabling these outcomes are not easily replicated. Context matters enormously, and planning policy should be sceptical of one-size-fits-all aviation development narratives.</p>",
    status: :draft,
    ai_generated: false,
    created_at: 2.weeks.ago
  },
  {
    title: "What Bangkok Can Teach Sydney About Transit-Oriented Development",
    blog_excerpt: "Bangkok's BTS Skytrain corridor has produced some of Southeast Asia's most striking examples of transit-oriented development. There are lessons here — and cautionary tales — for Australian cities.",
    body_html: "<h2>Bangkok's TOD Transformation</h2><p>When the BTS Skytrain opened in 1999, Bangkok was widely regarded as a cautionary tale of urban sprawl and traffic dysfunction. Two decades later, the corridors around Asok, Phrom Phong, and On Nut tell a different story: dense, walkable, mixed-use precincts that have fundamentally reshaped how middle-class Bangkokians live and move.</p><h2>Why It Worked</h2><p>Several factors converged: land assembly was made possible by Thailand's relatively concentrated land ownership patterns, the private-sector BTS operator had strong incentives to drive ridership through station-area development, and municipal planning was — perhaps unusually — flexible enough to permit density uplifts quickly.</p><h2>What Sydney Can Take From This</h2><p>Australian TOD aspirations are frequently frustrated by land fragmentation, slow rezonings, and infrastructure contribution regimes that make high-density development near stations financially marginal. Bangkok's experience suggests that the critical variable is not urban design ambition but implementation speed and landowner coordination. These are governance problems, not planning problems — and they are solvable.</p>",
    status: :published,
    ai_generated: true,
    created_at: 1.month.ago
  },
  {
    title: "The Role of Informal Settlements in Urban Planning Theory: Towards a More Inclusive Framework",
    blog_excerpt: "Informal settlements are often treated as planning failures to be managed or eradicated. I argue they are better understood as adaptive responses to housing market exclusion — and planning theory needs to catch up.",
    body_html: "<h2>Framing the Problem</h2><p>Mainstream urban planning theory has long struggled with informality. The dominant framing — inherited from 20th-century modernist planning — treats informal settlements as deviations from a planned norm: problems to be solved through slum clearance, forced relocation, or progressive upgrading.</p><h2>An Alternative Lens</h2><p>A growing body of scholarship, drawing on the work of Ananya Roy, Nezar AlSayyad, and others, argues that informality is better understood as a mode of urbanisation — not an exception to the rule, but a constitutive feature of how cities grow under conditions of rapid urbanisation and housing market exclusion.</p><h2>Implications for Practice</h2><p>If we accept this framing, the appropriate policy response shifts significantly. Rather than managing informality out of existence, planners should be asking how formal systems can adapt to recognise, support, and build upon the self-help housing strategies that millions of urban residents already employ. This is not a counsel of despair — it is a recognition that planning must meet people where they are.</p>",
    status: :draft,
    ai_generated: true,
    created_at: 4.days.ago
  }
]

blog_posts_data.each do |attrs|
  next if BlogPost.exists?(title: attrs[:title])

  post = user.blog_posts.build(
    title: attrs[:title],
    blog_excerpt: attrs[:blog_excerpt],
    status: attrs[:status],
    ai_generated: attrs[:ai_generated],
    created_at: attrs[:created_at]
  )

  if attrs[:ai_generated]
    post.blog_post_erb_content = attrs[:body_html]
  else
    post.body = attrs[:body_html]
  end

  post.save!
  puts "  - Blog post: #{post.title}"
end

# ===== RESEARCH ITEMS =====
puts "Seeding research items..."

research_data = [
  {
    title: "Cross-Border Regional Planning and Airport-Driven Urban Development: The Gold Coast Airport Case",
    category: :publication,
    description: "This doctoral thesis examines the governance and planning challenges arising from Gold Coast Airport's position on the Queensland–New South Wales border. Drawing on stakeholder interviews and comparative policy analysis, it develops a framework for cross-border planning coordination in airport regions.",
    external_url: "https://www.une.edu.au",
    featured: true,
    published_at: Date.new(2022, 11, 1)
  },
  {
    title: "Housing Affordability and Zoning Reform: A Comparative Analysis of Australian Capital Cities",
    category: :paper,
    description: "A peer-reviewed paper examining the relationship between zoning restrictiveness and housing supply elasticity across Sydney, Melbourne, and Brisbane. Finds that infill development constraints are the primary driver of affordability deterioration in inner and middle-ring suburbs.",
    external_url: "https://www.une.edu.au",
    featured: false,
    published_at: Date.new(2023, 4, 15)
  },
  {
    title: "Transit-Oriented Development Outcomes in Southeast Asian Cities: Implications for Australian Planning Policy",
    category: :paper,
    description: "A comparative study of TOD implementation in Bangkok, Singapore, and Kuala Lumpur, assessing what governance mechanisms, land-use frameworks, and financing models have driven successful station-area intensification. Draws lessons for the Australian context.",
    external_url: "https://www.une.edu.au",
    featured: false,
    published_at: Date.new(2024, 2, 28)
  },
  {
    title: "Airport City Development and Second-Tier Aviation Markets: Evidence from Australia and Southeast Asia",
    category: :project,
    description: "An ongoing research project investigating the economic and planning impacts of airport city development strategies at secondary airports in Australia and Southeast Asia. The project combines spatial analysis with qualitative case studies of Gold Coast, Avalon, Suvarnabhumi, and Kuala Lumpur International Airport.",
    external_url: nil,
    featured: true,
    published_at: Date.new(2024, 7, 1)
  }
]

research_data.each do |attrs|
  next if ResearchItem.exists?(title: attrs[:title])

  user.research_items.create!(
    title: attrs[:title],
    category: attrs[:category],
    description: attrs[:description],
    external_url: attrs[:external_url],
    featured: attrs[:featured],
    published_at: attrs[:published_at]
  )
  puts "  - Research: #{attrs[:title][0..60]}..."
end

# ===== GRANTS & AWARDS =====
puts "Seeding grants and awards..."

grants_data = [
  {
    title: "Australian Research Council Discovery Early Career Researcher Award (DECRA)",
    category: :grant,
    awarding_body: "Australian Research Council",
    year: 2023,
    description: "A three-year DECRA fellowship supporting research into cross-border governance frameworks for airport-adjacent urban development in Australia. The project will develop a practical policy toolkit for state and local governments managing development in multi-jurisdictional airport regions."
  },
  {
    title: "UNE Vice-Chancellor's Award for Excellence in Teaching",
    category: :award,
    awarding_body: "University of New England",
    year: 2023,
    description: "Awarded in recognition of outstanding contributions to student learning and innovative curriculum design in the urban planning program. Cited specifically for the introduction of authentic assessment formats that better reflect professional planning practice."
  },
  {
    title: "Planning Institute of Australia NSW Young Planner Award",
    category: :award,
    awarding_body: "Planning Institute of Australia (NSW Chapter)",
    year: 2021,
    description: "Awarded annually to a planning professional or academic under 35 who has demonstrated exceptional promise and contribution to the planning profession in New South Wales. Recognised for research impact and engagement with planning policy reform."
  }
]

grants_data.each do |attrs|
  next if GrantAward.exists?(title: attrs[:title])

  user.grant_awards.create!(
    title: attrs[:title],
    category: attrs[:category],
    awarding_body: attrs[:awarding_body],
    year: attrs[:year],
    description: attrs[:description]
  )
  puts "  - Grant/Award: #{attrs[:title][0..60]}..."
end

# ===== TEACHINGS =====
puts "Seeding teachings..."

teachings_data = [
  {
    title: "PLAN301 — Urban and Regional Planning Studio",
    institution: "University of New England",
    year: 2024,
    description: "A capstone studio unit for third-year planning students. Students work in multidisciplinary teams to develop a planning proposal for a real site, engaging with community stakeholders, local councils, and industry mentors. Assessment is based on oral presentations, stakeholder consultation reports, and a final planning proposal."
  },
  {
    title: "PLAN201 — Introduction to Land Use Planning",
    institution: "University of New England",
    year: 2024,
    description: "A core second-year unit introducing the theory and practice of land use planning in Australia. Topics include the NSW planning system, environmental impact assessment, development control plans, strategic planning frameworks, and the role of community participation. Includes site visits to local planning examples."
  },
  {
    title: "PLAN401 — Advanced Planning Theory and Policy",
    institution: "University of New England",
    year: 2023,
    description: "A postgraduate-level unit examining contemporary debates in planning theory, including communicative planning, informality, smart cities, climate adaptation, and decolonising planning practice. Students produce an original research essay engaging critically with planning literature and Australian policy examples."
  }
]

teachings_data.each do |attrs|
  next if Teaching.exists?(title: attrs[:title])

  user.teachings.create!(
    title: attrs[:title],
    institution: attrs[:institution],
    year: attrs[:year],
    description: attrs[:description]
  )
  puts "  - Teaching: #{attrs[:title]}"
end

puts "Seed complete."
