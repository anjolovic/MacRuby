n = (0..999).to_a.inject(0) { |b, i| b + i }.to_s

assert n, %{
  n = 0
  q = Dispatch::Queue.new('foo')
  g = Dispatch::Group.new
  1000.times do |i|
    g.dispatch(q) { n += i }
  end
  g.wait
  p n
}

assert n, %{
  n = 0
  q = Dispatch::Queue.new('foo')
  g = Dispatch::Group.new
  1000.times do |i|
    g.dispatch(Dispatch::Queue.concurrent) do
      g.dispatch(q) { n += i }
    end
  end
  g.wait
  p n
}

assert n, %{
  n = 0
  q = Dispatch::Queue.new('foo')
  g = Dispatch::Group.new
  1000.times do |i|
    g.dispatch(Dispatch::Queue.concurrent) do
      q.dispatch(true) { n += i }
    end
  end
  g.wait
  p n
}

assert n, %{
  n = 0
  q = Dispatch::Queue.new('foo')
  q.apply(1000) do |i|
    n += i
  end
  p n
}

assert n, %{
  n = 0
  q = Dispatch::Queue.new('foo')
  Dispatch::Queue.concurrent.apply(1000) do |i|
    q.dispatch { n += i }
  end
  q.dispatch(true) {}
  p n
}

assert ':ok', %{
  g = Dispatch::Group.new
  g.dispatch(Dispatch::Queue.concurrent) { raise('hey') }
  g.wait
  p :ok
}
