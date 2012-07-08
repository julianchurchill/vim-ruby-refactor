Feature: Extract method
    In order to more easily refactor my ruby code
    As a vim and ruby user
    I want to use the extract method refactoring within vim

    @wip
    Scenario: Extract method with parameters
        Given a ruby source buffer in vim with the following content:
            """
            def an_arbitrary_function( a, b )
              if a == b
                return "equal"
              end
              return "not equal"
            end
            """
        When I visually highlight "a == b"
        And I call the vim function "ExtractMethod"
        And I supply the argument "test_equality"
        Then the buffer should contain:
            """
            def an_arbitrary_function( a, b )
              if test_equality( a, b )
                return "equal"
              end
              return "not equal"
            end

            def test_equality( a, b )
              a == b
            end
            """
